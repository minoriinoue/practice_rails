class Admin::ThreadsController < Admin::BaseController
  def index
    @threads = MyThread.includes(:user)
  end

  def destroy
    if MyThread.find(params[:id]).destroy
      redirect_to admin_threads_url, notice: 'Successfully deleted a thread.'
    else
      redirect_to admin_threads_url, notice: 'Failed to delete a thread.'
    end
  end
end
