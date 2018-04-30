class DNASpiral {

    // properties
    PVector center_point;
    ArrayList <Vertex> spiral_vertices;
    ArrayList <Vertex> inner_vertices;
    float radius;
    float z;
    float z_increment;
    float height;

    DNASpiral(PVector center){
        center_point = center.copy();

        z = 0;
        z_increment = 12;
        radius = z_increment * 2.66;

        create_dna();
    }

    // main function used to shape form
    void create_dna(){

        spiral_vertices = new ArrayList<Vertex>();
        inner_vertices = new ArrayList<Vertex>();

        for (float a = 0; a < TWO_PI*2; a += 0.3){
            
            // FIRST SPIRAL
            float x1 = radius * cos(a);
            float y1 = radius * sin(a);
            this.z += this.z_increment;
            Vertex vertex_1 = new Vertex(x1, y1, this.z);
            vertex_1.col = color(255);
            vertex_1.size = 4;

            spiral_vertices.add(vertex_1);

            // SECOND SPIRAL
            float x2 = radius * cos(a + PI);
            float y2 = radius * sin(a + PI);
            Vertex vertex_2 = new Vertex(x2, y2, this.z);
            vertex_2.col = color(255);
            vertex_2.size = 4;

            spiral_vertices.add(vertex_2);

            // draw the connections between the two spirals
            float num_inner_vertices = 18.0;
            float inner_vertices_step = 1.0 / num_inner_vertices;
            for (float i = 0.0; i <= 1.0; i+=inner_vertices_step) {

                float px = lerp(x1, x2, i);
                float py = lerp(y1, y2, i);

                Vertex inner_vertex = new Vertex(px, py, this.z);
                inner_vertex.col = color(255);
                inner_vertex.size = 1.5;

                inner_vertices.add(inner_vertex);
            }
        }

        this.height = this.z;

    }

    // draws the points of the dna spirals
    void draw(PGraphics pg){

        pg.pushStyle();

        pg.beginShape(POINTS);
        // two spirals
        for (int i = 0; i < dna.spiral_vertices.size(); i++){
            Vertex vertex = dna.spiral_vertices.get(i);
            pg.stroke(vertex.col);
            pg.strokeWeight(vertex.size);
            pg.vertex(vertex.position.x, vertex.position.y, vertex.position.z);
        }
        pg.endShape();

        pg.beginShape(POINTS);
        // center vertices
        for (int i = 0; i < dna.inner_vertices.size(); i++){
            Vertex vertex = dna.inner_vertices.get(i);
            pg.stroke(vertex.col);
            pg.strokeWeight(vertex.size);
            pg.vertex(vertex.position.x, vertex.position.y, vertex.position.z);
        }
        pg.endShape();

        pg.popStyle();
    }

    void update(){
        // nothing to add here for the moment
    }

    void export(String name){

        beginRecord("nervoussystem.obj.OBJExport", name);
        
        // Save the DNA mesh
        MeshExport output = (MeshExport) createGraphics(10, 10, "nervoussystem.obj.OBJExport", name + ".obj");
        
        output.beginDraw();

        this.draw(output);
        
        output.endDraw();
        output.dispose();

        println(name + " export complete.");

        endRecord();
    }
}