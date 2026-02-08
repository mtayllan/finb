class ChatController < ApplicationController
  def index
    @messages = Current.user.chat_messages.includes(:created_transaction).recent
  end

  def create
    chat_message = ChatMessage.new(message: params[:message])

    if chat_message.save && chat_message.process
      redirect_to chat_index_path, notice: "Transaction created!"
    else
      redirect_to chat_index_path, alert: chat_message.errors.full_messages.presence&.to_sentence || chat_message.response
    end
  end
end
