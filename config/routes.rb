Rails.application.routes.draw do
  get 'collections', to: 'collections#index'
  get 'collections/scan', to: 'collections#scan'
  get 'collections/:collection/products', to: 'products#index'
  get 'collections/:collection/products/:order_by', to: 'products#index'
  get 'products/:product_handle/inventory/sku', to: 'sales#inventoryBySKU'
  get 'products/:product_handle/inventory', to: 'sales#inventoryByProduct'
  get '/', to: 'collections#index'
end
