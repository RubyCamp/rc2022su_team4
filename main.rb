require 'mittsu'
# 依存するファイル群を一括でrequireする
Dir.glob("lib/*.rb") {|path| require_relative path }

SCREEN_WIDTH = 800
SCREEN_HEIGHT = 600
ASPECT = SCREEN_WIDTH.to_f / SCREEN_HEIGHT.to_f


renderer = Mittsu::OpenGLRenderer.new width: SCREEN_WIDTH, height: SCREEN_HEIGHT, title: 'Hello, World!'

scene = Mittsu::Scene.new

camera = Mittsu::PerspectiveCamera.new(75.0, ASPECT, 0.1, 1000.0)
camera.position.z = 25

obstacle = Obstacle.new(color: 0x00ff00)
obstacle2 = Obstacle.new(color: 0x00ff00, offset: 5)
obstacle3 = Obstacle.new(color: 0x00ff00, offset: -6, phase: Math::PI)

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

obstacle2.mesh.position.x = 4

obstacle3.mesh.position.x = -6

scene.add(obstacle.mesh)

scene.add(obstacle2.mesh)

scene.add(obstacle3.mesh)

scene.add(sphere)

scene.add(sphere2)

scene.add(bullets)

scene.add(bullets2)

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

  if glfw_key == GLFW_KEY_X
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
  obstacle.play
  obstacle2.play
  obstacle3.play

  bullets.children.each do |bullet|
    bullet.position.x -= 0.1
    #puts bullet.position.x 
    if bullet.position.x < -20
      bullets.remove(bullet)
    end
    # 2つの球の間の距離を計算
    distance = bullet.position.distance_to(obstacle.mesh.position)
    distance2 = bullet.position.distance_to(obstacle2.mesh.position)
    distance5 = bullet.position.distance_to(sphere2.position)
    distance8 = bullet.position.distance_to(obstacle3.mesh.position)
    # 得られた距離が、互いの半径の合計値（1.0 + 0.5）以下になったら触れたと判定する
    if distance <= 1.5
      # シーンから大きい方の球を除去
      #scene.remove(bullet)
      bullets.remove(bullet)
    end
    if distance2 <= 1.5
      # シーンから大きい方の球を除去
      #scene.remove(bullet)
      bullets.remove(bullet)
    end
    if distance8 <= 1.5
      # シーンから大きい方の球を除去
      bullets.remove(bullet)
    end
    if distance5 <= 1.5
      # シーンから大きい方の球を除去
      scene.remove(sphere2)
    end
    bullets2.children.each do |bullet2| 
      distance7 = bullet.position.distance_to(bullet2.position)
      if distance7 <= 1.5
        #シーンから大きい方の球を除去
        bullets.remove(bullet)
        bullets2.remove(bullet2)
      end
    end

  end
  
  bullets2.children.each do |bullet2|
    bullet2.position.x += 0.1
    #puts bullet2.position.x 
    if bullet2.position.x > 22
      bullets2.remove(bullet2)
    end
    # 2つの球の間の距離を計算
    distance3 = bullet2.position.distance_to(obstacle.mesh.position)
    distance4 = bullet2.position.distance_to(obstacle2.mesh.position)
    distance6 = bullet2.position.distance_to(sphere.position)
    distance9 = bullet2.position.distance_to(obstacle3.mesh.position)
    # 得られた距離が、互いの半径の合計値（1.0 + 0.5）以下になったら触れたと判定する
    if distance3 <= 1.5
      # シーンから大きい方の球を除去
      #scene.remove(bullet)
      bullets2.remove(bullet2)
    end
    if distance4 <= 1.5
      # シーンから大きい方の球を除去
      #scene.remove(bullet)
      bullets2.remove(bullet2)
    end
    if distance9 <= 1.5
      # シーンから大きい方の球を除去
      #scene.remove(bullet)
      bullets2.remove(bullet2)
    end
    if distance6 <= 1.5
      # シーンから大きい方の球を除去
      scene.remove(sphere)
    end
  end

  renderer.render(scene, camera)
end