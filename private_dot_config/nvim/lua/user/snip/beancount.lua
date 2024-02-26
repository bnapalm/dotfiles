local ls = require("luasnip")
local s = ls.snippet
local i = ls.insert_node
local fmt = require("luasnip.extras.fmt").fmt

return {

  s("tx", fmt([[
{date} * "{payee}" "{desc}"
  {acc1}             {amount} EUR
  {acc2}
        ]], {
    date = i(1, (function()
      return os.date("%Y-%m-%d")
    end)()),
    payee = i(2, "payee"),
    desc = i(3, "description"),
    acc1 = i(4, "account"),
    amount = i(5, "0.00"),
    acc2 = i(0, "account"),
  }))
}
