require_relative 'base'

module Directors
	# ゲーム本編のシーン制御用ディレクタークラス
	class Game < Base
        def initialize(renderer:, aspect:)
            super 

            self.camera.position.z = 25
            @paused = false

            @obstacle = Obstacle.new(color: 0x00ff00)
            @obstacle2 = Obstacle.new(color: 0x00ff00, offset: 5)
            @obstacle3 = Obstacle.new(color: 0x00ff00, offset: -6, phase: Math::PI)
            @obstacle4 = Obstacle.new(color: 0x00ff00, offset: -4, phase: Math::PI)

			@pause_board = TextBoard.new(texture_path: "textures/title_vs_com.png", value:0,z:20)

            add_lights 

            @sphere = Player.new(color: 0x0000ff)
            @sphere2 = Player.new(color: 0x0000ff)

            @bullets = Mittsu::Group.new

            @bullets2 = Mittsu::Group.new

            @sphere.mesh.position.x = 20.0

            @sphere2.mesh.position.x = -20.0

            @obstacle2.mesh.position.x = 4

            @obstacle3.mesh.position.x = -6

            @obstacle4.mesh.position.x = 8

            self.scene.add(@obstacle.mesh)

            self.scene.add(@obstacle2.mesh)

            self.scene.add(@obstacle3.mesh)

            self.scene.add(@obstacle4.mesh)

            self.scene.add(@sphere.mesh)

            self.scene.add(@sphere2.mesh)

            self.scene.add(@bullets)

            self.scene.add(@bullets2)

            @renderer.window.on_key_pressed do |glfw_key|
                if glfw_key == GLFW_KEY_P
                    @paused = !@paused
                    if @paused
                        self.scene.add(@pause_board.mesh)
                    else
                        self.scene.remove(@pause_board.mesh)
                    end
                end
                # 押下されたキーがスペースキーであれば、新規の弾丸メッシュを生成してシーンと配列に
                # 格納する
                # ※ 簡単のためライトをセットしていないので、MeshBasicMaterialを使っている
                if !@paused
                    if glfw_key == GLFW_KEY_SPACE
                    geometry = Mittsu::SphereGeometry.new(0.5, 8, 8)
                    material = Mittsu::MeshBasicMaterial.new(color: 0xff0000)
                    bullet = Mittsu::Mesh.new(geometry, material)
                    #弾をプレイヤーの位置から撃つ関数
                    bullet.position = @sphere.mesh.position.clone
                    @bullets.add(bullet)
                    end
                    if glfw_key == GLFW_KEY_RIGHT
                    @sphere.mesh.position.x += 2
                    end
                    if glfw_key == GLFW_KEY_LEFT
                    @sphere.mesh.position.x -= 2
                    end
                    if glfw_key == GLFW_KEY_UP
                    @sphere.mesh.position.y += 2
                    end
                    if glfw_key == GLFW_KEY_DOWN
                    @sphere.mesh.position.y -= 2
                    end
                
                    if glfw_key == GLFW_KEY_X
                    geometry = Mittsu::SphereGeometry.new(0.5, 8, 8)
                    material = Mittsu::MeshBasicMaterial.new(color: 0xff0000)
                    bullet2 = Mittsu::Mesh.new(geometry, material)
                    bullet2.position = @sphere2.mesh.position.clone
                    @bullets2.add(bullet2)
                    end
                    if glfw_key == GLFW_KEY_D
                    @sphere2.mesh.position.x += 2
                    end
                    if glfw_key == GLFW_KEY_A
                    @sphere2.mesh.position.x -= 2
                    end
                    if glfw_key == GLFW_KEY_W
                    @sphere2.mesh.position.y += 2
                    end
                    if glfw_key == GLFW_KEY_S
                    @sphere2.mesh.position.y -= 2
                    end
                end
            end
        end

        def play
            if !@paused
                @obstacle.play
                @obstacle2.play
                @obstacle3.play
                @obstacle4.play


                @bullets.children.each do |bullet|
                    bullet.position.x -= 0.1
                    #puts bullet.position.x 
                    if bullet.position.x < -20
                        @bullets.remove(bullet)
                    end
                    # 2つの球の間の距離を計算
                    distance = bullet.position.distance_to(@obstacle.mesh.position)
                    distance2 = bullet.position.distance_to(@obstacle2.mesh.position)
                    distance5 = bullet.position.distance_to(@sphere2.mesh.position)
                    distance8 = bullet.position.distance_to(@obstacle3.mesh.position)
                    distance10 = bullet.position.distance_to(@obstacle4.mesh.position)
                    # 得られた距離が、互いの半径の合計値（1.0 + 0.5）以下になったら触れたと判定する
                    if distance <= 1.5 && !@obstacle.destroyed?
                    # シーンから大きい方の球を除去
                    #scene.remove(bullet)
                        @obstacle.hit
                        if @obstacle.destroyed?
                            self.scene.remove(@obstacle.mesh)
                        end
                        @bullets.remove(bullet)
                    end
                    if distance2 <= 1.5 && !@obstacle2.destroyed?
                    # シーンから大きい方の球を除去
                    #scene.remove(bullet)
                    @obstacle2.hit
                    if @obstacle2.destroyed?
                        self.scene.remove(@obstacle2.mesh)
                    end
                        @bullets.remove(bullet)
                    end
                    if distance8 <= 1.5  && !@obstacle3.destroyed?
                    # シーンから大きい方の球を除去
                    @obstacle3.hit
                    if @obstacle3.destroyed?
                        self.scene.remove(@obstacle3.mesh)
                    end
                        @bullets.remove(bullet)
                    end
                    if distance10 <= 1.5 && !@obstacle4.destroyed?
                        # シーンから大きい方の球を除去
                        @obstacle4.hit
                        if @obstacle4.destroyed?
                            self.scene.remove(@obstacle4.mesh)
                        end
                        @bullets.remove(bullet)
                    end
                    if distance5 <= 1.5
                    # シーンから大きい方の球を除去
                        self.scene.remove(@sphere2.mesh)
                    end
                    @bullets2.children.each do |bullet2| 
                        distance7 = bullet.position.distance_to(bullet2.position)
                        if distance7 <= 1.5
                            #シーンから大きい方の球を除去
                            @bullets.remove(bullet)
                            @bullets2.remove(bullet2)
                        end
                    end
                end
                
                @bullets2.children.each do |bullet2|
                    bullet2.position.x += 0.1
                    #puts bullet2.position.x 
                    if bullet2.position.x > 22
                        @bullets2.remove(bullet2)
                    end
                    # 2つの球の間の距離を計算
                    distance3 = bullet2.position.distance_to(@obstacle.mesh.position)
                    distance4 = bullet2.position.distance_to(@obstacle2.mesh.position)
                    distance6 = bullet2.position.distance_to(@sphere.mesh.position)
                    distance9 = bullet2.position.distance_to(@obstacle3.mesh.position)
                    distance11 = bullet2.position.distance_to(@obstacle4.mesh.position)
                    # 得られた距離が、互いの半径の合計値（1.0 + 0.5）以下になったら触れたと判定する
                    if distance3 <= 1.5 && !@obstacle.destroyed?
                    # シーンから大きい方の球を除去
                    #scene.remove(bullet)
                    @obstacle.hit
                    if @obstacle.destroyed?
                        self.scene.remove(@obstacle.mesh)
                    end
                        @bullets2.remove(bullet2)
                    end
                    if distance4 <= 1.5 && !@obstacle2.destroyed?
                    # シーンから大きい方の球を除去
                    #scene.remove(bullet)
                    @obstacle2.hit
                    if @obstacle2.destroyed?
                        self.scene.remove(@obstacle2.mesh)
                    end
                        @bullets2.remove(bullet2)
                    end
                    if distance9 <= 1.5 && !@obstacle3.destroyed?
                    # シーンから大きい方の球を除去
                    #scene.remove(bullet)
                    @obstacle3.hit
                    if @obstacle3.destroyed?
                        self.scene.remove(@obstacle3.mesh)
                    end
                        @bullets2.remove(bullet2)
                    end
                    if distance11 <= 1.5 && !@obstacle4.destroyed?
                        # シーンから大きい方の球を除去
                        #scene.remove(bullet)
                        @obstacle4.hit
                        if @obstacle4.destroyed?
                            self.scene.remove(@obstacle4.mesh)
                        end
                        @bullets2.remove(bullet2)
                    end
                    if distance6 <= 1.5
                    # シーンから大きい方の球を除去
                        self.scene.remove(@sphere.mesh)
                    end
                end
            end
            return self
        end
        def add_lights
			# 文字ボードを照らすための照明
			text_light = Mittsu::AmbientLight.new(0xffffff)
			#text_light.angle = Math::PI / 2
			text_light.position.set(0, 1, 25)
			self.scene.add(text_light)
		end
    end
    

end
