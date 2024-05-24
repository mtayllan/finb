class H1Component < ViewComponent::Base
  erb_template <<-ERB
    <h1 class="scroll-m-20 text-4xl font-bold tracking-tight">
      <%= content %>
    </h1>
  ERB
end
