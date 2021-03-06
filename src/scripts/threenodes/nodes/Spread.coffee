define [
  'use!Underscore', 
  'use!Backbone',
  'order!threenodes/utils/Rc4Random',
  'order!threenodes/models/Node',
], (_, Backbone, Rc4Random) ->
  "use strict"
  
  $ = jQuery
  
  class ThreeNodes.nodes.RandomSpread extends ThreeNodes.NodeBase
    @node_name = 'RandomSpread'
    @group_name = 'Spread'
    
    set_fields: =>
      super
      @auto_evaluate = true
      @rnd = false
      @value = false
      @seed = false
      @count = false
      @width = false
      @offset = false
      @fields.addFields
        inputs:
          "count": 1
          "seed" : 1
          "width" : 1
          "offset": 0
        outputs:
          "out" : 0
      
      @v_out = @fields.getField("out", true)
    
    remove: () =>
      delete @v_out
      super
    
    compute: =>
      needs_rebuild = false
      if @seed != @fields.getField("seed").get("value") || @count != parseInt(@fields.getField("count").getValue(0)) || @width != @fields.getField("width").get("value") || @offset != @fields.getField("offset").get("value")
        @seed = @fields.getField("seed").get("value")
        @rnd = new Rc4Random(@seed.toString())
        
        @value = []
        @width = @fields.getField("width").getValue(0)
        @offset = @fields.getField("offset").getValue(0)
        @count = parseInt(@fields.getField("count").get("value"))
        for i in [0..@count - 1]
          @value[i] = @rnd.getRandomNumber() * @width - @width / 2 + @offset
      @fields.setField("out", @value)
  
  class ThreeNodes.nodes.LinearSpread extends ThreeNodes.NodeBase
    @node_name = 'LinearSpread'
    @group_name = 'Spread'
    
    set_fields: =>
      super
      @auto_evaluate = true
      @value = false
      @count = false
      @width = false
      @phase = false
      @offset = false
      @fields.addFields
        inputs:
          "count": 1
          "width" : 1
          "phase" : 0
          "offset": 0
        outputs:
          "out" : 0
      
      @v_out = @fields.getField("out", true)
    
    remove: () =>
      delete @v_out
      super
    
    compute: =>
      needs_rebuild = false
      @width = @fields.getField("width").getValue(0)
      @offset = @fields.getField("offset").getValue(0)
      @phase = @fields.getField("phase").getValue(0)
      @count = parseInt(@fields.getField("count").getValue())
      @value = []
      
      stepSize = @width / @count
      shift = stepSize / 2
      for i in [0..@count - 1]
        res = ( i * stepSize + shift + @phase ) % @width
        res = @offset - @width / 2 + res
        @value[i] = res
      @fields.setField("out", @value)
      