class Hash
  def slice(*whitelist)
    whitelist.inject({}) { |result, key|
      if self.key? key
        result.merge(key => self[key])
      else
        result
      end
    }
  end
end
