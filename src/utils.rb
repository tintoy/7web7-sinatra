class Hash
  def slice(*whitelist)
    whitelist.inject({}) { |result, key|
      result.merge(key => self[key])
    }
  end
end
