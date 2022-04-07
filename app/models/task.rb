class Task < ApplicationRecord
  # CSVデータをインポートする
  def self.import(file)
    CSV.foreach(file.path, headers: true) do |row|
      task = new
      task.attributes = row.to_hash.slice(*csv_attributes)
      task.save!
    end
  end
  # CSVデータをどの属性をどの順番でどの出力するか設定
  def self.csv_attributes
    ["name", "description", "created_at", "updated_at"]
  end

  # CSV出力
  def self.generate_csv
    CSV.generate(headers: true) do |csv|
      # ヘッダを出力
      csv << csv_attributes
      # allメソッドで全タスクを取得
      all.each do |task|
        csv << csv_attributes.map{ |attr| task.send(attr) }
      end
    end
  end

  has_one_attached :image

  def self.ransackable_attributes(auth_abject = nil)
    %w[name created_at]
  end

  def self.ransackable_associations(auth_object = nil)
    []
  end

  # before_validation :set_nameless_name
  validates :name, presence: true, length: { maximum: 30 }
  validate :validate_name_not_including_comma

  belongs_to :user

  scope :recent, -> { order(created_at: :desc) }

  private
  
  # def set_nameless_name
  #   self.name = '名前なし' if name.blank?
  # end
  # nameがnilの場合に例外が発生するのを避けるため、&.を利用する
  def validate_name_not_including_comma
    errors.add(:name, 'にカンマを含めることはできません') if name&.include?(',')
  end
end
