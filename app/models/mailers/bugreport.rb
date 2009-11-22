module Mailers::Bugreport

  # Send an email letting the user know that a page has been 'sent' to them.
  def send_bugreport(params, options)
    setup(options)
    recipients options[:dev_email] 
    subject 'Crabgrass Bug Report'
    body({:site => Site.current, :user => params[:user], :backtrace => params[:full_backtrace], 
      :exception_class => params[:execption_class], :error_controller => params[:error_controller], 
      :error_action=>params[:error_action], :exception_message => params[:exception_detailed_message],
      :comments => params[:comments], :uri => params[:uri], :referer => params[:referer], :context => params[:context]})
    content_type "text/plain"
  end

end
