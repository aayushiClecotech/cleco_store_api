ActiveAdmin.register Product do

  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # Uncomment all parameters which should be permitted for assignment
  #
   permit_params :title, :product_description, :price, :old_price, :exclusive_price, :image, :product_details, :category_id, :is_published, :sub_category_id, :sale, :is_recommended, product_media_files_attributes: [:id, :image, :_destroy]
  #
  # or
  #
  # permit_params do
  #   permitted = [:title, :product_description, :price, :old_price, :exclusive_price, :image, :product_details, :category_id, :is_published]
  #   permitted << :other if params[:action] == 'create' && current_user.admin?
  #   permitted
  # end

  index do
    selectable_column
    id_column
    column :title
    column :price
    column :image
    column :old_price
    column :exclusive_price
    column :category
    column :sub_category
    actions
  end

  show do
    attributes_table do
      row :title
      row :price
      row :old_price
      row :old_price
      row :exclusive_price
      row :product_description do |product|
        raw product.product_description
      end
      row :product_details do |product|
        raw product.product_details
      end
      row :image do |product|
        image_tag url_for(product&.image), height: 200, width: 200 if product&.image.attached?
      end
      row :product_media_files
    end
  end

  # controller do
  #   before_action :get_category_id, only: [:create, :update]
  #   def create
  #     @product = Product.new(product_params)
  #     if @product.save
  #       redirect_to admin_products_path
  #     else
  #       render :new
  #     end 
  #   end

  #   private
  #   def get_category_id
  #     category_id = SubCategory.find(params[:product][:sub_category_id]).category_id
  #     @product = Product.update(category_id: category_id)
  #     # category_id = Product.sub_categories.category_id
  #   end
    
  #   def product_params
  #     params.require(:product).permit(:title, :product_description, :price, :old_price, :exclusive_price, :image, :product_details, :category_id, :is_published, :sub_category_id, :sale)
  #   end

  # end

  form do |f|
    f.inputs do
      f.input :title
      f.input :price
      # f.input :old_price
      # f.input :exclusive_price
      f.input :image, as: :file
      # f.input :category_id, :as => :select, :collection => Category&.all.collect {|r| [r.name, r.id] }
      f.input :sub_category_id, :as => :select, :collection => SubCategory&.all.collect {|r| [r.name, r.id] }
      f.input :sale, :as => :select, :collection => Sale&.all.collect {|r| [r.title, r.id] }, multiple: false
      # if f.object.persisted?
      #   f.input :recommended_products, :as => :select, :collection => f.object.recommended_products.collect {|r| [r.title, r.id] }, multiple: true
      # end
      f.input :product_details, as: :quill_editor#, input_html: { data: { options: { modules: { toolbar: [['bold', 'italic', 'underline'], ['link']] }, placeholder: 'Type something...', theme: 'snow' } } }
      f.input :product_description, as: :quill_editor#, input_html: { data: { options: { modules: { toolbar: [['bold', 'italic', 'underline'], ['link']] }, placeholder: 'Type something...', theme: 'snow' } } }
      f.input :is_published
      f.input :is_recommended
      f.has_many :product_media_files do |c|
        c.input :image, as: :file#,  :hint => c.template.image_tag(c.object.images.url(:thumb))
        c.input :_destroy, :as => :boolean
      end
    end
    f.actions
  end
end
