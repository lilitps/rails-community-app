class LocalesController < ApplicationController
  include LocalesHelper

  # HTTP 	    URL	            Action	    Named route	            Purpose
  # request
  # PATCH	    /locales/	      update	    locale_path(local)

  def update
    remember(params[:locale])
    flash[:success] = t('locale_set_to', language: t('language_name'))
    redirect_to root_path
  end
end
