require 'mittsu'

SCREEN_WIDTH = 800
SCREEN_HEIGHT = 600
ASPECT = SCREEN_WIDTH.to_f / SCREEN_HEIGHT.to_f


renderer = Mittsu::OpenGLRenderer.new width: SCREEN_WIDTH, height: SCREEN_HEIGHT, title: 'Hello, World!'

scene = Mittsu::Scene.new

camera = Mittsu::PerspectiveCamera.new(75.0, ASPECT, 0.1, 1000.0)
camera.position.z = 25

count = 0

box = Mittsu::Mesh.new(
  Mittsu::BoxGeometry.new(3.0, 3.0, 3.0),
  Mittsu::MeshBasicMaterial.new(color: 0x00ff00)
)
box2 = Mittsu::Mesh.new(
  Mittsu::BoxGeometry.new(3.0, 3.0, 3.0),
  Mittsu::MeshBasicMaterial.new(color: 0x0ff000)
)

sphere = Mittsu::Mesh.new(
  Mittsu::SphereGeometry.new(1, 160, 160),
  Mittsu::MeshBasicMaterial.new(color: 0x0000ff)
)

sphere2 = Mittsu::Mesh.new(
  Mittsu::SphereGeometry.new(1, 160, 160),
  Mittsu::MeshBasicMaterial.new(color: 0x0000ff)
)

bullets = Mittsu::Group.new

bullets2 = Mittsu::Group.new

sphere.position.x = 20.0

sphere2.position.x = -20.0

box2.position.x = 4

box2.position.y = 2

scene.add(box)

scene.add(box2)

scene.add(sphere)

scene.add(sphere2)

scene.add(bullets)

scene.add(bullets2)

#
renderer.window.on_key_pressed do |glfw_key|
  # 押下されたキーがスペースキーであれば、新規の弾丸メッシュを生成してシーンと配列に
  # 格納する
  # ※ 簡単のためライトをセットしていないので、MeshBasicMaterialを使っている
  if glfw_key == GLFW_KEY_SPACE
    geometry = Mittsu::SphereGeometry.new(0.5, 8, 8)
    material = Mittsu::MeshBasicMaterial.new(color: 0xff0000)
    bullet = Mittsu::Mesh.new(geometry, material)
    #弾をプレイヤーの位置から撃つ関数
    bullet.position = sphere.position.clone
    bullets.add(bullet)
  end
  if glfw_key == GLFW_KEY_RIGHT
    sphere.position.x += 2
  end
  if glfw_key == GLFW_KEY_LEFT
    sphere.position.x -= 2
  end
  if glfw_key == GLFW_KEY_UP
    sphere.position.y += 2
  end
  if glfw_key == GLFW_KEY_DOWN
    sphere.position.y -= 2
  end

  if glfw_key == GLFW_KEY_ENTER
    geometry = Mittsu::SphereGeometry.new(0.5, 8, 8)
    material = Mittsu::MeshBasicMaterial.new(color: 0xff0000)
    bullet2 = Mittsu::Mesh.new(geometry, material)
    bullet2.position = sphere2.position.clone
    bullets2.add(bullet2)
  end
  if glfw_key == GLFW_KEY_D
    sphere2.position.x += 2
  end
  if glfw_key == GLFW_KEY_A
    sphere2.position.x -= 2
  end
  if glfw_key == GLFW_KEY_W
    sphere2.position.y += 2
  end
  if glfw_key == GLFW_KEY_S
    sphere2.position.y -= 2
  end
end

renderer.window.run do
  box.position.y = Math.sin(count*0.05)*8
  box2.position.y = Math.sin(count*0.05)*8+5
  #1フレームごとに1カウントが上がる
  count +=1

  bullets.children.each do |bullet|
    bullet.position.x -= 0.1
    puts bullet.position.x 
    if bullet.position.x < -20
      bullets.remove(bullet)
    end
  end
  
  bullets2.children.each do |bullet2|
    bullet2.position.x += 0.1
    puts bullet2.position.x 
    if bullet2.position.x > 22
      bullets2.remove(bullet2)
    end
  end


  renderer.render(scene, camera)
end
