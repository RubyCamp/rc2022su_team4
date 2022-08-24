class Player
    attr_reader :mesh
    def initialize(color:)
        @mesh = Mittsu::Mesh.new(
            Mittsu::SphereGeometry.new(1, 160, 160),
            Mittsu::MeshBasicMaterial.new(color: color)
          )
    end
           

end