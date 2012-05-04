module UsuariosHelper

  def gravatar_image_tag(email)
    email = Digest::MD5.hexdigest(email)
    image_tag "http://www.gravatar.com/avatar/#{email}", alt: "Imagem Gravatar", size: "48x48"
  end

end
