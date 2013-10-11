class CreateCourses < ActiveRecord::Migration
  def change
    create_table :courses do |t|
      t.string :department_code
      t.integer :call_number
      t.string :term
      t.string :section_full
      t.string :course_title
      t.text :description
      t.integer :num_fixed_units
      t.string :room
      t.string :building_1

      # http://guides.rubyonrails.org/association_basics.html
      # http://stackoverflow.com/questions/9934308/rails-one-model-with-two-associations
      t.belongs_to :professor, 
        class_name: "User",
        -> { where isprofessor: true }, 
        index: true

      t.has_many :students,
        class_name: "User"

      t.timestamps
    end
  end
end
