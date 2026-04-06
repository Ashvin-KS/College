// ==========================================
// PART 1: Hybrid Network Topology Creation
// Topology: Hybrid (Ring + Star + Bus)
// Total Nodes: 25
// ==========================================

clear;
clc;

// ---------------------------------------------------------
// STEP 1: Define Network Connections (Edges)
// ---------------------------------------------------------
NameOfNetwork = 'Hybrid Topology (Ring-Star-Bus)';
NumberOfNodes = 25; 

// A. RING TOPOLOGY (Nodes 1-5) - The Core
ring_tails = [1 2 3 4 5];
ring_heads = [2 3 4 5 1];

// B. STAR TOPOLOGY (Center Node 6, connected to Ring Node 1)
// Bridge connection: Ring(1) -> StarCenter(6)
bridge_star_tail = [1];
bridge_star_head = [6];
// Star Leaves: Center(6) connects to Nodes 7-15
star_tails = [6 6 6 6 6 6 6 6 6];
star_heads = [7 8 9 10 11 12 13 14 15];

// C. BUS TOPOLOGY (Starts Node 16, connected to Ring Node 3)
// Bridge connection: Ring(3) -> BusStart(16)
bridge_bus_tail = [3];
bridge_bus_head = [16];
// Bus Line: Nodes 16 -> 17 -> ... -> 25
bus_tails = [16 17 18 19 20 21 22 23 24];
bus_heads = [17 18 19 20 21 22 23 24 25];

// Combine all vectors into one graph definition
TailVector = [ring_tails bridge_star_tail star_tails bridge_bus_tail bus_tails];
HeadVector = [ring_heads bridge_star_head star_heads bridge_bus_head bus_heads];

// ---------------------------------------------------------
// STEP 2: Define Coordinates (X, Y) for Visualization
// ---------------------------------------------------------
// Ring Coordinates (Center)
X_Ring = [500 600 500 400 500];
Y_Ring = [600 500 400 500 700];

// Star Coordinates (Left Side)
X_StarCenter = [300]; 
Y_StarCenter = [500];
// Leaves arranged in a semi-circle around center
X_StarLeaves = [200 200 200 250 350 400 400 400 300];
Y_StarLeaves = [400 500 600 700 700 600 500 400 300];

// Bus Coordinates (Right Side - Linear)
X_Bus = [700 750 800 850 900 950 1000 1050 1100 1150];
Y_Bus = [500 500 500 500 500 500 500 500 500 500];

// Combine all coordinates
X_Coords = [X_Ring X_StarCenter X_StarLeaves X_Bus];
Y_Coords = [Y_Ring Y_StarCenter Y_StarLeaves Y_Bus];

// ---------------------------------------------------------
// STEP 3: Create the Graph Object
// ---------------------------------------------------------
[TopologyGraph] = NL_G_MakeGraph(NameOfNetwork, NumberOfNodes, TailVector, HeadVector, X_Coords, Y_Coords);

// ---------------------------------------------------------
// STEP 4: Operation A & B - Display and Number Nodes
// ---------------------------------------------------------
WindowIndex = 1;
[GraphVisual] = NL_G_ShowGraph(TopologyGraph, WindowIndex);
xtitle("Hybrid Topology: Ring(Center), Star(Left), Bus(Right)", "X-Nodes", "Y-Nodes");

// ---------------------------------------------------------
// STEP 5: Operation C - Colour the Nodes and Edges
// ---------------------------------------------------------
// Instead of using HighlightNodes repeatedly (which overwrites previous colors),
// we modify the graph properties directly to show all colors at once.

// Define Colors: 2=Blue, 3=Green, 5=Red, 30=Black
NodeColors = 30 * ones(1, NumberOfNodes); // Initialize all to Black
NodeDiameters = 20 * ones(1, NumberOfNodes);
NodeBorders = 5 * ones(1, NumberOfNodes);

// Set Ring Nodes (1-5) to Blue (2)
NodeColors(1:5) = 2;
NodeDiameters(1:5) = 40; // Make Ring nodes slightly bigger

// Set Star Nodes (6-15) to Green (3)
NodeColors(6:15) = 3;

// Set Bus Nodes (16-25) to Red (5)
NodeColors(16:25) = 5;

// Apply properties to the graph object
TopologyGraph.node_color = NodeColors;
TopologyGraph.node_diam = NodeDiameters;
TopologyGraph.node_border = NodeBorders;

// Display the Coloured Graph in a new window
WindowIndex = 2;
[GraphVisualColoured] = NL_G_ShowGraphN(TopologyGraph, WindowIndex);
xtitle("Coloured Hybrid Topology (Blue=Ring, Green=Star, Red=Bus)", "X-Nodes", "Y-Nodes");

// ---------------------------------------------------------
// STEP 6: Operation D - Edge Counts & Max Edges
// ---------------------------------------------------------
disp("===========================================");
disp("         EDGE ANALYSIS PER NODE            ");
disp("===========================================");

MaxEdges = 0;
NodeWithMax = 0;

for i = 1:NumberOfNodes
    // Calculate degree (Incoming + Outgoing edges)
    // find() returns indices where the node number appears
    degree = length(find(TailVector == i)) + length(find(HeadVector == i));
    
    printf("Node %d has %d edges.\n", i, degree);
    
    // Check if this is the maximum
    if degree > MaxEdges then
        MaxEdges = degree;
        NodeWithMax = i;
    end
end

printf("\n-------------------------------------------\n");
printf("NODE WITH MAXIMUM EDGES:\n");
printf("Node %d is the hub with %d edges.\n", NodeWithMax, MaxEdges);
printf("-------------------------------------------\n");

// ---------------------------------------------------------
// STEP 7: Operation E - Total Nodes and Edges
// ---------------------------------------------------------
[TotalNodes, TotalEdges] = NL_G_GraphSize(TopologyGraph);

disp("===========================================");
disp("           NETWORK SUMMARY                 ");
disp("===========================================");
printf("Total Number of Nodes: %d\n", TotalNodes);
printf("Total Number of Edges: %d\n", TotalEdges);
disp("===========================================");
