class CreateLabels < ActiveRecord::Migration
  def change
    create_table :labels do |t|
      t.integer :eval_id
      t.integer :www_id
      t.integer :nowww_id
      t.integer :assessor_id
      t.integer :adult
      t.integer :spam
      t.integer :news_editorial
      t.integer :commercial
      t.integer :educational_research
      t.integer :discussion
      t.integer :personal_leisure
      t.integer :media
      t.integer :database
      t.integer :readability_vis
      t.integer :readability_lang
      t.integer :neutrality
      t.integer :bias
      t.integer :trustiness
      t.integer :confidence

      t.timestamps null: false
    end
  end
end
