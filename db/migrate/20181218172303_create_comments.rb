class CreateComments < ActiveRecord::Migration[5.2]
  def change
 
      create_table :comments do |c|

      	c.text    :name
      	c.text    :comment
      	c.integer :post_id

		c.timestamps #automatically create 2 datetimes
 	 end
  end # def
end#class
