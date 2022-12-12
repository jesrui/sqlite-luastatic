
local sqlite3 = require("lsqlite3")

local db = sqlite3.open_memory()

db:exec[[
  CREATE TABLE test (id INTEGER PRIMARY KEY, content);

  INSERT INTO test VALUES (NULL, 'Hello World');
  INSERT INTO test VALUES (NULL, 'Hello Lua');
  INSERT INTO test VALUES (NULL, 'Hello Sqlite3');

create table user(id INTEGER PRIMARY KEY,name,phone);

insert into user (name, phone) values("oz", json('{"cell":"+491765", "home":"+498973"}'));

]]

--[[
for row in db:nrows("SELECT * FROM test") do
  print(row.id, row.content)
end
]]--

for row in db:nrows("select * from user where user.name=='oz'") do
  print(row.id, row.name, row.phone)
end


for row in db:nrows("select json_extract(user.phone, '$.cell') as cell from user") do
  for k,v in pairs(row)	do
				print(k,v)
  end
end
