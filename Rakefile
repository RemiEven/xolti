require 'rake/testtask'

Rake::TestTask.new do |task|
	task.libs << 'test'
	task.test_files = FileList['test/**/tc*.rb']
end

desc 'Run tests'
task(default: [:test])
