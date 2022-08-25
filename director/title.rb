require_relative 'base'

module Directors
	# タイトル画面のシーン制御用ディレクタークラス
	class Title < Base
		# コンストラクタ
		def initialize(renderer:, aspect:)
			# スーパークラスのコンストラクタ実行
			super

			# タイトル画面の次に遷移する画面（ゲーム本編）用のディレクターオブジェクトを生成
			@game_director = Directors::Game.new(renderer: renderer, aspect: aspect)

			# 地球のメッシュを生成してシーンに追加
			@earth = MeshFactory.get_earth
			self.scene.add(@earth)

			# テキスト用ボードオブジェクト追加
			vs_com_board = TextBoard.new(texture_path: "textures/title_vs_com.png", value: 0)
			self.scene.add(vs_com_board.mesh)

			# 光源追加
			add_lights

			# Mittsuのイベントをアクティベート（有効化）する
			#activate_events
		end

		# 1フレーム分のゲーム進行処理
		def render_frame
			# 少しずつ地球のメッシュを回転させる（自転を表現）
			@earth.rotate_y(0.001)

			if @renderer.window.key_down?(GLFW_KEY_ENTER)
				transition_scene
			end
		end

		private
	    
		# シーン切り替え実行
		def transition_scene
			# 次のシーンを担当するディレクターのMittsuイベントのアクティベートを行う。
			# ※ シーンを切り替える瞬間に行わないと、後発のディレクターのイベントハンドラで先発のイベントハンドラが
			#    上書きされてしまうため、このタイミングで実行する。
			#@game_director.activate_events

			# next_directorアクセサを切り替えることで、次のフレームの描画からシーンが切り替わる。
			# ※ このメカニズムはmain.rb側のメインループで実現している点に注意
			self.next_director = @game_director
		end

		# シーンに光源を追加
		def add_lights
			# 地球を照らすための照明
			earth_light = Mittsu::DirectionalLight.new(0xffffff)
			earth_light.position.set(5, 10, 5)
			self.scene.add(earth_light)

			# 文字ボードを照らすための照明
			text_light = Mittsu::SpotLight.new(0xffffff)
			text_light.angle = Math::PI / 2
			text_light.position.set(0, -1, 10)
			self.scene.add(text_light)
		end
	end
end
