# Computer Networks Lab Task 2
**Student:** Ashvin K S (24BCE1580)

## Overview
This project implements a hybrid network topology with 25 nodes using Scilab, combining three basic topologies (Ring, Star, and Bus). The implementation includes visualization, node/edge numbering, coloring, network analysis, and failure scenario analysis.

## Part 1: Hybrid Topology Creation and Analysis 

### Topology Design
The hybrid topology consists of:
- **Ring Topology (Nodes 1-5, Blue)**: Central control servers in a ring formation for redundancy
- **Star Topology (Nodes 6-15, Green)**: Department switch (Node 6) with robotic arms (Nodes 7-15)
- **Bus Topology (Nodes 16-25, Red)**: Conveyor belt sensor array in daisy-chain configuration

### Network Connections
The topology is defined using tail and head vectors in [`lab.sce`](lab.sce:37-38):

```scilab
TailVector = [ring_tails bridge_star_tail star_tails bridge_bus_tail bus_tails];
HeadVector = [ring_heads bridge_star_head star_heads bridge_bus_head bus_heads];
```

### Implementation Steps

#### 1. Topology Creation
The graph is created using [`NL_G_MakeGraph()`](lab.sce:65):
```scilab
[TopologyGraph] = NL_G_MakeGraph(NameOfNetwork, NumberOfNodes, TailVector, HeadVector, X_Coords, Y_Coords);
```

#### 2. Visualization and Numbering
The network is displayed with numbered nodes using [`NL_G_ShowGraph()`](lab.sce:71):

![Basic Topology Visualization](Screenshot%202025-12-17%20185453.png)
*Figure 1: Basic hybrid topology with numbered nodes showing Ring (center), Star (left), and Bus (right) configurations*

```scilab
[GraphVisual] = NL_G_ShowGraph(TopologyGraph, WindowIndex);
```

#### 3. Node Coloring
Nodes are colored by topology type (lines 86-93):

![Colored Topology Visualization](Screenshot%202025-12-17%20185512.png)
*Figure 2: Colored topology showing Ring nodes in Blue, Star nodes in Green, and Bus nodes in Red*

- **Ring Nodes (1-5)**: Blue (color code 2)
- **Star Nodes (6-15)**: Green (color code 3)
- **Bus Nodes (16-25)**: Red (color code 5)

#### 4. Edge Analysis
The code calculates each node's degree (number of connections) in the loop at [`lab.sce`](lab.sce:115-127):
```scilab
for i = 1:NumberOfNodes
    degree = length(find(TailVector == i)) + length(find(HeadVector == i));
    printf("Node %d has %d edges.\n", i, degree);
end
```

**Node with Maximum Edges**: Node 6 (Star center/hub) with 10 edges.

#### 5. Network Summary
Total counts are obtained using [`NL_G_GraphSize()`](lab.sce:137):
- **Total Nodes**: 25
- **Total Edges**: 29

## Part 2: Failure Scenario Analysis

### Failure Event
A forklift accident causes two simultaneous failures:
1. **Uplink cable cut**: Between Control Server Node 1 and Department Switch Node 6
2. **Sensor cable unplugged**: Between Sensor Node 19 and Sensor Node 20

### Impact Analysis

#### 1. Star Topology Impact (Nodes 6-15)
- **Entire Star cluster becomes isolated** from the Ring topology
- **Affected Nodes**: 6, 7, 8, 9, 10, 11, 12, 13, 14, 15
- **Consequence**: Department switch and all robotic arms lose contact with Central Control Servers
- **Status**: **NON-FUNCTIONAL** (disconnected from core network)

#### 2. Bus Topology Impact (Nodes 16-25)
The bus line is split into two segments:

**Functional Segment (Upstream):**
- **Nodes**: 16, 17, 18, 19
- **Status**: **FUNCTIONAL** (remain connected to Ring via Node 3)
- **Connection Path**: Ring Node 3 → Bus Node 16 → 17 → 18 → 19

**Isolated Segment (Downstream):**
- **Nodes**: 20, 21, 22, 23, 24, 25
- **Status**: **NON-FUNCTIONAL** (disconnected from Central Servers)
- **Reason**: Break between Node 19 and Node 20 severs connection to the Ring

### Summary of Functional vs Non-Functional Nodes

**FUNCTIONAL Nodes (Still in contact with Central Control Servers):**
- Ring: 1, 2, 3, 4, 5
- Bus (Upstream): 16, 17, 18, 19
- **Total**: 9 nodes

**NON-FUNCTIONAL Nodes (Lost contact with Central Control Servers):**
- Star: 6, 7, 8, 9, 10, 11, 12, 13, 14, 15
- Bus (Downstream): 20, 21, 22, 23, 24, 25
- **Total**: 16 nodes

## Code Structure

### Main File
- [`lab.sce`](lab.sce): Complete implementation of both tasks

### Key Functions Used
1. [`NL_G_MakeGraph()`](lab.sce:65) - Creates the network graph object
2. [`NL_G_ShowGraph()`](lab.sce:71) - Displays basic topology visualization
3. [`NL_G_ShowGraphN()`](lab.sce:102) - Displays colored topology visualization
4. [`NL_G_GraphSize()`](lab.sce:137) - Returns total nodes and edges

### Network Parameters
- **Total Nodes**: 25
- **Total Edges**: 29
- **Ring Nodes**: 5 (Blue)
- **Star Nodes**: 10 (Green)
- **Bus Nodes**: 10 (Red)

## How to Run

### Prerequisites
- Scilab installed with Network Toolbox
- Required functions: `NL_G_MakeGraph`, `NL_G_ShowGraph`, `NL_G_ShowGraphN`, `NL_G_GraphSize`

### Execution Steps
1. Open Scilab
2. Navigate to the project directory
3. Run the command: `exec('lab.sce')`
4. The script will generate two visualization windows and print analysis results to the console

### Expected Output
1. **Window 1**: Basic topology with numbered nodes
2. **Window 2**: Colored topology (Blue=Ring, Green=Star, Red=Bus)
3. **Console Output**:
   - Edge count for each node
   - Node with maximum edges
   - Total nodes and edges count
   - Failure analysis summary

## Network Design Rationale

### Ring Topology (Center)
- **Purpose**: Central control servers with redundancy
- **Advantage**: If one connection fails, data flows the other way
- **Color**: Blue for identification

### Star Topology (Left)
- **Purpose**: Department switch controlling robotic arms
- **Structure**: Node 6 as hub, Nodes 7-15 as leaves
- **Color**: Green for identification

### Bus Topology (Right)
- **Purpose**: Conveyor belt sensor array
- **Structure**: Linear daisy-chain from Node 16 to 25
- **Color**: Red for identification

## Failure Scenario Insights

The analysis demonstrates:
1. **Single point of failure**: The bridge connections (Node 1→6 and Node 3→16) are critical
2. **Cascading failures**: Cutting one uplink isolates an entire topology segment
3. **Bus segmentation**: Cable breaks split the bus into functional and non-functional segments
4. **Redundancy importance**: The ring topology provides some fault tolerance for the core network

## Conclusion
This implementation successfully demonstrates hybrid network topology creation, visualization, analysis, and failure scenario evaluation using Scilab. The code is production-ready with clear documentation, proper structuring, and comprehensive error analysis capabilities.