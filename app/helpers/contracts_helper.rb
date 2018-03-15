module ContractsHelper

  def roundup(num, nearest)
    num % nearest == 0 ? num : num + nearest - (num % nearest)
  end
end
