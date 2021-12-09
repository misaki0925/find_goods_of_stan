class LineUser < ApplicationRecord
  enum yugo:{ necessary: 0, unnecessary: 1 }, _prefix: true
  enum taiga:{ necessary: 0, unnecessary: 1 }, _prefix: true
  enum juri:{ necessary: 0, unnecessary: 1 }, _prefix: true
  enum hokuto:{ necessary: 0, unnecessary: 1 }, _prefix: true
  enum jess:{ necessary: 0, unnecessary: 1 }, _prefix: true
  enum shintarou:{ necessary: 0, unnecessary: 1 }, _prefix: true

  def yugo_on
    yugo_necessary!
    @name = "高地優吾" 
  end

  def yugo_off 
    yugo_unnecessary!
    @name = "高地優吾" 
  end

  def taiga_on
    taiga_necessary!
    @name = "京本大我" 
  end

  def taiga_off 
    taiga_unnecessary!
    @name = "京本大我" 
  end

  def juri_on
    juri_necessary!
    @name = "田中樹" 
  end

  def juri_off 
    juri_unnecessary!
    @name = "田中樹" 
  end

  def hokuto_on
    hokuto_necessary!
    @name = "松村北斗" 
  end

  def hokuto_off 
    hokuto_unnecessary!
    @name = "松村北斗"  
  end

  def jess_on
    jess_necessary!
    @name = "ジェシー" 
  end

  def jess_off 
    jess_unnecessary!
    @name = "ジェシー" 
  end

  def shintarou_on
    shintarou_necessary!
    @name = "森本慎太郎" 
  end

  def shintarou_off 
    shintarou_unnecessary!
    @name = "森本慎太郎" 
  end

end
