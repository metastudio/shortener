class MmUser
  key :name, String
  def test(val)
    update({:name => "andrey"})
  end
end