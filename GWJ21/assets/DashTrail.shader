shader_type particles;

uniform vec4 default_color : hint_color;
uniform bool invert = false;

void vertex()
{
	if(RESTART)
	{
		TRANSFORM = EMISSION_TRANSFORM;
		if(invert)
		{
			TRANSFORM[0][0] *= -1.0;
		}
		TRANSFORM[0].xyz *= 4.0;
		TRANSFORM[1].xyz *= 4.0;
		TRANSFORM[2].xyz *= 4.0;
	}
	
	CUSTOM.x += DELTA / LIFETIME;
	
	COLOR = vec4(default_color.r, default_color.g, default_color.b, default_color.a * (1.0-CUSTOM.x));
}