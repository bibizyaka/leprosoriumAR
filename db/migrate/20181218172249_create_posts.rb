class CreatePosts < ActiveRecord::Migration[5.2]
  def change
     create_table :posts do |p|

     	p.text :name
     	p.text :content


     	p.timestamps #automatically crate 2 datetime fields
     end #do
  end #def
end #class
