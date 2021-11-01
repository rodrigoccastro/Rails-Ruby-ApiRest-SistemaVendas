# Rails-Ruby-ApiRest-Vendas
Api em ruby on rails para sistema de vendas


1. Config inicial 
	a) executar rails new SalesSystem --api
	b) cd SalesSystem
	c) criar database SalesSystem no banco MySql
	d) executar gem install mysql2
	e) alterar arquivo /config/database.yml
		default: &default
			adapter: mysql2
			username: root
			password: barnabe123
			pool: <%= ENV.fetch("RAILS_MAX_THREADS") { 5 } %>
			timeout: 5000

		development:
			<<: *default
			database: SalesSystem

		test:
			<<: *default
			database: SalesSystem

		production:
			<<: *default
			database: SalesSystem

	f) alterar arquivo /gemfile
		comentar esta linha: # gem 'sqlite3'
		adicionar esta linha: gem 'mysql2'

2. Criar Rotas...
	a) add linha em config/routes.rb
		Rails.application.routes.draw do
  			resources :client
  			resources :seller
  			resources :product
  			resources :sale
		end
	b) executar linha: bin/rails routes

3. Criar Model
	a) comandos de criação
		bin/rails generate model client number:string name:string email:string phone:string address:string
		bin/rails generate model seller number:string name:string email:string phone:string address:string
		bin/rails generate model product name:string description:text value:float
		bin/rails generate model sale client:references seller:references 
		bin/rails generate model productsale sale:references product:references value:float quantity:integer

	b) Abrir arquivos model e colocar validacao e conexões conforme arquivos no git: 
    		. Open the app/models/client.rb file and edit
				class Client < ApplicationRecord
  					validates :number, presence: true
					  validates :name,  presence: true
					  has_many :sales
				end
		. Open the app/models/seller.rb file and edit it:
				class Seller < ApplicationRecord
  					validates :number, presence: true
					  validates :name,  presence: true
					  has_many :sales
				end
		. Open the app/models/product.rb file and edit it:
				class Product < ApplicationRecord
					validates :name,  presence: true
					validates :description,  presence: true
					validates :value,  presence: true
					has_many :productsales
				end
		. Open the app/models/sale.rb file and edit it:
				class Sale < ApplicationRecord
					belongs_to :client
					belongs_to :seller
					has_many :productsales
				end
		. Open the app/models/productsale.rb file and edit it:
				class Productsale < ApplicationRecord
  					validates :value, presence: true
					validates :quantity,  presence: true
					belongs_to :sale
					belongs_to :product
				end

	c) Criar tabelas no banco por meio do comando:
		bin/rails db:migrate

4. Criar Controller da home
	a) Criar arquivos controller dentro da pasta /app/controllers/
		client_controller.rb 
		seller_controller.rb 
		product_controller.rb 
		sale_controller.rb 
	b) Abrir arquivos controllers e adicionar código aqui no git...


