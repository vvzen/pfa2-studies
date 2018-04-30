#include "DifferentialLine.h"

//--------------------------------------------------------------
void DifferentialLine::add_node(Node * n){
    nodes.push_back(n);
}

//--------------------------------------------------------------
void DifferentialLine::add_node_at(Node * n, int index){
    nodes.insert(nodes.begin() + index, n);
}

//--------------------------------------------------------------
// Whenever the distance from a node to the other becomes too big, add new nodes in between
//--------------------------------------------------------------
void DifferentialLine::grow(){

    // loop through all nodes
    for (int i = 0; i < nodes.size(); i++){
        
        Node * node_1 = nodes.at(i);
        Node * node_2;

        // if we are in the body of the vector,
        // just get the node after this one
        if (i != nodes.size()-1){
            node_2 = nodes.at(i+1);
        }
        // if this is the last element of the vector,
        // grab the first one
        else {
            node_2 = nodes.at(0);
        }

        float distance = node_1->pos.distance(node_2->pos);
        // cout << "edge length: " << distance << endl;

        // add a new node in the middle of the distance is too high
        // and we haven't reached the maximum number of nodes
        if (distance > MAX_EDGE_LENGTH && nodes.size() < MAX_NODES_NUM){
            
            ofVec2f mid_position = node_1->pos.getInterpolated(node_2->pos, 0.5f);
            
            Node * new_node = new Node(mid_position);
            nodes.insert(nodes.begin()+i+1, new_node);
        }
    }
}

//--------------------------------------------------------------
// Compute the flocking behaviours
//--------------------------------------------------------------
void DifferentialLine::differentiate(){

    for (int i = 0; i < nodes.size(); i++){
        Node * node = nodes.at(i);
        node->update(nodes);
    }
}

//--------------------------------------------------------------
// Draw as points or lines, or both
// Uses two ofMesh-es
//--------------------------------------------------------------
void DifferentialLine::draw(bool lines, bool vertices){

    lines_mesh.clear();

    ofMesh points_mesh;
    points_mesh.setMode(OF_PRIMITIVE_POINTS);

    for (int i = 0; i < nodes.size(); i++){
        Node * node = nodes.at(i);
        if (lines) lines_mesh.addVertex(node->pos);
        if (vertices) points_mesh.addVertex(node->pos);
    }

    if (lines) lines_mesh.draw();
    if (vertices) points_mesh.draw();
}

//--------------------------------------------------------------
void DifferentialLine::reset(){

    nodes.clear();
}