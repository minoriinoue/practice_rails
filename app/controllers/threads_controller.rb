class ThreadsController < UserBaseController
  def index
    if params[:status].present?
      following_user_id = Follow.where(follower_id: current_user.id).pluck(:followee_id)
      @threads = MyThread.where(user_id: following_user_id).includes(:user)
    else
      @threads = MyThread.includes(:user)
    end
  end

  def new
    @thread = MyThread.new
  end

  def create
    user_params = params.require(:my_thread).permit(:title, :description)
    user_params[:user_id] = current_user.id
    @thread = MyThread.new(user_params)
    if @thread.save
      @thread = MyThread.new
      flash[:notice] = 'Successfully created a new thread.'
      render :new
    else
      flash[:alert] = 'Could not create a new thread.'
      render :new
    end
  end

  def edit
    @thread = MyThread.find(params[:id])
  end

  def update
    thread_params = params.require(:my_thread).permit(:my_thread_id, :title, :description)
    @thread = MyThread.find(thread_params[:my_thread_id])
    if !thread_params[:title].empty?
      @thread.title = thread_params[:title]
    end
    if !thread_params[:description].empty?
      @thread.description = thread_params[:description]
    end

    if @thread.save
      flash[:notice] = 'Successfully updated.'
      render :edit
    else
      flash[:alert] = 'Failed to update.'
      render :edit
    end
  end

  def destroy
    if current_user.id == MyThread.find(params[:id]).user_id
      if MyThread.find(params[:id]).destroy
        flash[:notice] = 'Successfully deleted a thread.'
        @threads = MyThread.includes(:user)
        render :index
      else
        flash[:alert] = 'Failed to delete a thread.'
        @threads = MyThread.includes(:user)
        render :index
      end
    else
      flash[:alert] = 'You are not authorized to delete a thread.'
      @threads = MyThread.includes(:user)
      render :index
    end
  end
end
