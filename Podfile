platform :ios, '13.0'

def testing_pods
    pod 'Quick', '3.0.0', :inhibit_warnings => true
    pod 'Nimble', '9.0.0', :inhibit_warnings => true
end


target 'RedditProject' do

   pod 'RxSwift', '5.1.1'
   pod 'RxCocoa', '5.1.1'
   pod 'SDWebImage', '5.10.0', :modular_headers => true

  target 'RedditProjectTests' do
    inherit! :search_paths
    # Pods for testing
   testing_pods
  end

end
