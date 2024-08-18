json.array! @transactions do |transaction|
  json.description transaction.description

  json.category do
    json.id transaction.category_id
    json.name transaction.category.name
    json.color transaction.category.color
    json.icon transaction.category.icon
  end

  json.account do
    json.id transaction.account_id
    json.name transaction.account.name
    json.color transaction.account.color
  end
end
