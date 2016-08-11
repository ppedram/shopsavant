Rails.application.routes.draw do
  get 'collections', to: 'collections#index'
  get 'collections/scan', to: 'collections#scan'
  get 'collections/:collection/products', to: 'products#index'
  get 'products/:product_handle/sales/sku', to: 'sales#inventoryBySKU'
  get 'products/:product_handle/sales', to: 'sales#inventoryByProduct'
end
