class Obstacle
  attr_reader :mesh

  def initialize(color:, offset: 0,phase: 0)
    @mesh = Mittsu::Mesh.new(
      Mittsu::BoxGeometry.new(3.0, 3.0, 3.0),
      Mittsu::MeshBasicMaterial.new(color: color)
    )
    @offset = offset
    @phase = phase
    @count = 0
    @hp = 3
    @vanished = false
  end

  def play
    @mesh.position.y = Math.sin(@count*0.05+@phase)*8 + @offset
    @count += 1
  end
  def hit
    @hp -=1
  end
  def destroyed?
    @hp < 1
  end
end