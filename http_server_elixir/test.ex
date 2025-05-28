defmodule MyModule do
  def func(name) do
    "Hello, World!#{name}"
    "new"
  end
end

text = MyModule.func("gambhir")
IO.puts(text)
