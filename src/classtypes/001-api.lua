--creation of api ClassType--
class:append(class:newType("lfrt:api", {
  constructor = function(cls, clst, api, id, version)
  	log('creating api: ' .. id .. ' version ' .. version)
    local a = {VERSIONS={}, id=id}
    if cls:getById("api", id) then
      a = cls:getByID("api", id)
    end
    a.VERSIONS[version] = api
    return a
  end
}))