class ArticlesController < ApplicationController

	http_basic_authenticate_with name:"dhh",password:"secret",except: [:index,:show]

	def index
		@articles=Article.all
	end

	def new 
	   @article=Article.new                                 #if this is not present then @article will be nil when we visit the 
	                                                         #page for the first time and hence it will throw an error 
	                                                         #'undefined method on @article.errors method'  
	end

	def edit
		@article=Article.find(params[:id])
	end

	def create 
		# @article=Article.new(params[:article])            #due to strong parameters we need to whitelist the parameters that 
															#we want to set as attributes in model
		@article=Article.new(article_params)

		if !@article.save
			render new_article_path                          # Here render will pass @article back to the new template,and this 
			                                                 #rendering is done within the same request as the form submission 
			                                                 #which is unlike redirect_to
		else
			redirect_to @article                            #This and the below statement both works fine for show action
			# redirect_to article_path(@article)          
		end                         
	end

	def update
		@article=Article.find(params[:id])
		if @article.update(article_params)
			redirect_to @article
		else
			render 'edit'
		end
	end

	def destroy
		@article=Article.find(params[:id])
		@article.destroy

		redirect_to articles_path
	end

	def show
		@article=Article.find(params[:id])
		# render plain: @article.inspect
	end

	private

	def article_params
		params.require(:article).permit(:title,:text)
	end
end
