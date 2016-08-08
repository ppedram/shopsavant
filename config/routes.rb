Rails.application.routes.draw do
  get 'collections', to: 'collections#scan'
  get 'collections/:collection/products', to: 'products#scan'
  get 'products/:product_handle/sales', to: 'sales#index'
end
