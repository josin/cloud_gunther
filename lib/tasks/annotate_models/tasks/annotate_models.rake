require File.join(File.dirname(__FILE__), "../lib/annotate_models.rb")

desc "Add schema information (as comments) to model files"
task :annotate_models do
   AnnotateModels.do_annotations
end

# namespace :db do
#   task :migrate do
#     AnnotateModels.do_annotations
#   end
# 
#   namespace :migrate do
#     [:up, :down, :reset, :redo].each do |t|
#       task t do
#         AnnotateModels.do_annotations
#       end
#     end
#   end
# end