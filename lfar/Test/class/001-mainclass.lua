--create needed types--
--items
class:append(class:newType('opentycoon:Item', {
	constructor = function(cls, clst, item)
		function item:buy(amount)
			local game = cls:getAPI('opentycoon:game', 0)
			if game.session.money >= amount * self.price then
				game.session.money = game.session.money - amount * self.price
				self.amount = self.amount + amount
				game.push()
				self.push()
				return true game.session.money, self.price * amount
			else
				return false, game.session.money, self.price * amount
			end
		end
		function self:sell(amount)
			local game = cls:getAPI('opentycoon:game', 0)
			if self.amount >= amount then
				game.session.money = game.session.money - amount * (self.price * self.profit)
				self.amount = self.amount - amount
				game.push()
				self.push()
				return true (self.price * self.profit) * amount, amount
			else
				return false, (self.price * self.profit) * amount, amount
			end
		end
		return item
	end,
}))
--command
local cmds = {}
do
	class:append(class:newType('opentycoon:Command', {
		constructor = function(cls, clsT, id, man, cb)
			cmds[id:split(':')[2]] = {id=id, help=man, cb=cb}
			return {id=id, help=man, cb=cb}
		end,
		execute = function(name, ...)
			return pcall(cmd[name].cb, ...)
		end,
	}))
end