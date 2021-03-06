class Admin::ProductsController < ApplicationController

	before_action :authenticate_user!
	before_action :require_is_admin

	layout "admin"

	def index
		if params[:search]
			@products = Product.search(params[:search]).order("created_at DESC")
		else
			@products = Product.first(8)
		end

		unless @products.any?
			render :no_result_admin
		end

	end

	def no_result_admin
	end

	def new
		@product = Product.new
	end

	def create
		@product = Product.new(product_params)
		if @product.save
			redirect_to admin_products_path
		else
			render :new
		end
	end

	def show
		@product = Product.find(params[:id])
	end

	def destroy
		@product = Product.find(params[:id])
		@product.destroy
		flash[:alert] = "已成功删除"
		redirect_to admin_products_path
	end

	def update
		@product = Product.find(params[:id])
		if @product.update(product_params)
			redirect_to admin_products_path, notice: "更新成功"
		else
			render :edit
		end
	end

	def edit
		@product = Product.find(params[:id])

	end

	private

	def product_params
		params.require(:product).permit(:title, :description, :price, :quantity, :image,{photos: []})
	end




end
