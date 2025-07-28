# Funcionalidade de Divisão de Transações (Transaction Splits)

## Visão Geral
Esta funcionalidade permitirá que usuários dividam transações entre si, mantendo o controle de quem deve o que para quem. O sistema continuará mostrando apenas a parte proporcional de cada usuário nos relatórios e cálculos de saldo.

## Modelos de Dados

### 1. Split Model
```ruby
# app/models/split.rb
class Split < ApplicationRecord
  belongs_to :source_transaction, class_name: 'Transaction'
  belongs_to :payer, class_name: 'User'           # Quem pagou originalmente
  belongs_to :owes_to, class_name: 'User'         # Quem deve
  belongs_to :owes_to_category, class_name: 'Category', optional: true

  validates :amount_owed, presence: true, numericality: { greater_than: 0 }
  validates :payer_id, :owes_to_id, presence: true
  validates :source_transaction_id, uniqueness: true
  validate :users_must_be_different
  validate :amount_cannot_exceed_transaction_value
  validate :owes_to_category_belongs_to_owes_to_user
end
```

**Atributos:**
- `source_transaction_id` (integer, not null) - Transação original
- `payer_id` (integer, not null) - ID do usuário que pagou
- `owes_to_id` (integer, not null) - ID do usuário que deve
- `amount_owed` (decimal, not null) - Valor devido
- `owes_to_category_id` (integer, optional) - Categoria escolhida pelo devedor
- `paid_at` (datetime, optional) - Data do pagamento (quando marcado como pago)
- `created_at`, `updated_at` (datetime)

### 2. User Model (extensão)
```ruby
# Adicionar ao app/models/user.rb
has_many :splits_as_payer, class_name: 'Split', foreign_key: 'payer_id'
has_many :splits_as_owes_to, class_name: 'Split', foreign_key: 'owes_to_id'

def all_splits
  Split.where('payer_id = ? OR owes_to_id = ?', id, id)
end
```

### 3. Transaction Model (extensão)
```ruby
# Adicionar ao app/models/transaction.rb
has_one :split, foreign_key: 'source_transaction_id', dependent: :destroy

# Virtual attribute para valor final após split (apenas para relatórios)
def final_value
  return value unless split&.payer_id == account.user_id
  value - split.amount_owed
end

def has_split?
  split.present?
end

def splittable?
  # Transações podem ser divididas se não tiverem split ainda
  !has_split?
end
```

## Controllers e Rotas

### 1. Splits Controller
**Rota:** `/splits`

**Funcionalidades:**
- `index` - Dashboard principal com 3 abas
- `update` - Marcar como pago/não pago e definir categoria
- `destroy` - Remover split

**Abas do Index:**
1. **From Me** (splits onde eu paguei)
2. **To Me** (splits onde eu devo)
3. **Summary** (resumo mensal por usuário)

### 2. Transaction::Splits Controller (nested)
**Rota:** `/transactions/:transaction_id/splits`

**Funcionalidades:**
- `new` - Formulário para criar split
- `create` - Criar novo split
- `edit` - Editar split existente
- `update` - Atualizar split

## Interface do Usuário

### 1. Splits Dashboard (`/splits`)

#### Aba 1: From Me (Splits que eu paguei)
```
┌─────────────────────────────────────────────────────────────┐
│ Janeiro 2024                                                │
├─────────────────────────────────────────────────────────────┤
│ [🍕] Jantar                             $50.00              │
│ Split: Eu $30 (60%) | João $20 (40%)                       │
│ Status: [Pago ✓ em 15/01] | [Pendente ⏳]                   │
│ Ações: [Marcar Pago/Pendente] [Editar] [Excluir]           │
└─────────────────────────────────────────────────────────────┘
```

#### Aba 2: To Me (Splits que eu devo)
```
┌─────────────────────────────────────────────────────────────┐
│ Janeiro 2024                                                │
├─────────────────────────────────────────────────────────────┤
│ Uber - Centro                           $25.00              │
│ Split: Maria $15 (60%) | Eu $10 (40%)                      │
│ Status: [Pendente ⏳]                                       │
│ Categoria: [Selecionar ▼] [Transporte]                     │
└─────────────────────────────────────────────────────────────┘
```

#### Aba 3: Summary (Resumo mensal)
```
┌─────────────────────────────────────────────────────────────┐
│ Eu ↔ João - Janeiro 2024                                   │
├─────────────────────────────────────────────────────────────┤
│ Eu gastei: $500.00                                         │
│ João gastou: $200.00                                       │
│ Eu devo: $100.00                                           │
│ João deve: $250.00                                         │
│ ────────────────────                                       │
│ Total: $700.00                                             │
│ Resultado: João deve me $150.00                           │
└─────────────────────────────────────────────────────────────┘
```

### 2. Formulário de Split (`/transactions/:id/splits/new`)
```
┌─────────────────────────────────────────────────────────────┐
│ Dividir: Jantar - $50.00                                   │
│ Conta: Cartão Principal                                    │
│ Categoria: Alimentação                                     │
│ Data: 15/01/2024                                           │
├─────────────────────────────────────────────────────────────┤
│ Dividir com: [João Silva ▼]                               │
│                                                            │
│ João deve: [$20.00]                                       │
│ Eu fico com: $30.00 (calculado automaticamente)           │
│                                                            │
│ [Dividir Igualmente: $25 cada] [João paga 40%: $20]      │
│                                                            │
│ [Criar Split] [Cancelar]                                  │
└─────────────────────────────────────────────────────────────┘
```

### 3. Lista de Transações (modificação)
- Adicionar botão "Split" ao lado de cada transação (apenas para transações que podem ser divididas)
- Mostrar indicador visual quando transação tem split
- Continuar exibindo valor original da transação (saldo da conta não muda)
- Adicionar coluna ou indicação do valor final do usuário após split nos relatórios

## Impactos no Sistema

### 1. Relatórios (Controllers que precisam de ajuste)
- `HomeController#calculate_expenses_from` - usar `final_value`
- `Reports::ExpensesByCategoriesController` - incluir splits categorizados
- `Reports::IncomeByCategoriesController` - incluir splits categorizados
- `ReportsController` - usar `final_value` nos gráficos

### 2. Cálculo de Saldos
- **Saldos das contas permanecem inalterados** - continuam usando `value` da transação original
- Splits afetam apenas os relatórios de categoria, não o saldo da conta
- O saldo da conta reflete o valor real movimentado, independente da divisão

### 3. Importação/Exportação
- `DataManagement::Export` - incluir splits no JSON
- `DataManagement::Import` - processar splits na importação

## Validações e Regras de Negócio

### 1. Validações de Segurança
- **Sistema familiar**: Todos os usuários podem criar splits entre si
- Usuário não pode criar split consigo mesmo
- Valor do split não pode exceder valor da transação
- Categoria do devedor deve pertencer ao usuário devedor
- Cada transação pode ter apenas 1 split

### 2. Regras de Divisão
- **Uma transação = um split**: Divisão sempre entre 2 pessoas (pagador + devedor)
- Valor do split (`amount_owed`) representa quanto o devedor deve ao pagador
- Valor restante (`value - amount_owed`) fica com o pagador
- Qualquer tipo de transação pode ser dividida (conta corrente, cartão de crédito, etc.)

### 3. Estados do Split
- **Pendente**: Split criado, aguardando confirmação de pagamento
- **Pago**: Split marcado como pago pelo credor
- **Contestado**: Devedor contesta o split (funcionalidade futura)

## Casos de Uso Complexos Identificados

### 1. **Transações de Cartão de Crédito**
- **Comportamento**: Transações de cartão podem ser divididas normalmente
- **Saldo do statement**: Continua mostrando valor integral da transação
- **Split**: Afeta apenas relatórios de categoria, não o statement do cartão

### 2. **Exclusão de Transações com Split**
- **Comportamento**: Ao excluir transação, o split também é excluído automaticamente (dependent: :destroy)
- **Validação**: Sistema deve alertar usuário que o split será perdido
- **Histórico**: Considerar log de splits excluídos para auditoria

### 3. **Alteração de Valor da Transação**
- **Comportamento**: Se valor da transação for alterado, validar se split ainda é válido
- **Regra**: `amount_owed` não pode ser maior que novo valor da transação
- **UX**: Sugerir reajuste proporcional do split ou exclusão

### 4. **Transfers vs Splits**
- **Diferença clara**: Transfers são entre contas do mesmo usuário, Splits são entre usuários diferentes
- **Regra**: Transfers não podem ter splits
- **Saldo**: Transfers afetam saldo das contas, Splits afetam apenas relatórios de categoria

### 5. **Simplificação do Modelo**
- **Uma transação = um split máximo**: Elimina complexidade de múltiplos splits
- **Duas pessoas apenas**: Sempre pagador vs devedor, nunca divisão entre 3+ pessoas
- **Facilita UX**: Interface mais simples, cálculos mais diretos

## Tarefas de Implementação

### Fase 1: Modelos e Migrations
- [x] Criar migration para tabela `splits`
- [x] Implementar modelo `Split` com validações
- [x] Estender modelos `User` e `Transaction`
- [x] Adicionar método `final_value` virtual

### Fase 2: Controllers e Rotas ✅
- [x] Implementar `SplitsController`
- [x] Implementar `Transactions::SplitsController`
- [x] Configurar rotas nested
- [x] Implementar autenticação/autorização

### Fase 3: Views e JavaScript
- [ ] Dashboard de splits com 3 abas
- [ ] Formulário de criação/edição
- [ ] Componentes Stimulus para cálculos dinâmicos
- [ ] Turbo frames para atualizações sem reload

### Fase 4: Ajustes nos Relatórios
- [ ] Atualizar `HomeController`
- [ ] Atualizar controllers de reports
- [ ] Ajustar consultas para usar `final_value`
- [ ] Incluir splits categorizados nos relatórios

### Fase 5: Import/Export
- [ ] Estender `DataManagement::Export`
- [ ] Estender `DataManagement::Import`
- [ ] Atualizar estrutura JSON
- [ ] Testes de integridade

### Fase 6: UX e Polimento
- [ ] Adicionar botão "Split" na lista de transações
- [ ] Indicadores visuais para transações com splits
- [ ] Notificações para splits pendentes
- [ ] Testes de usabilidade

## Considerações Técnicas

### 1. Performance
- Indexar tabela splits adequadamente
- Considerar cache para cálculos de summary
- Paginação para listas grandes de splits

### 2. Testes
- Focar em testes de modelo para validações
- Testes de integração para fluxo completo
- Manter cobertura mínima conforme diretrizes do projeto

### 3. Compatibilidade
- Garantir que sistema funciona sem splits
- Migrations devem ser reversíveis
- Não quebrar funcionalidade existente


