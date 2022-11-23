<?php
include 'routedata_config.php';
include 'busstops.php';
include 'route_arrays.php';
error_reporting(E_ALL);
ini_set('display_errors', 1);
$conn = new PDO("mysql:host=$servername;port=25060;dbname=route_data", $username, $password, $options);
try {
    //post the city, farebox number and, street
    $location = $_POST['city'] ? trim($_POST['city']): null;
    if($location == "Knoxville") {
        $boxnumber = $_POST['boxnumber'] ? trim($_POST['boxnumber']): null;
        $street = $_POST['street'] ? trim($_POST['street']): null;
        if($boxnumber != null && $street != null) {
            //if condition based on each box number
            if($boxnumber == "11023") {
                //side table where count is updated as long as route is unknown for the day
                $sql = "UPDATE route_counter SET ridership_counter = ridership_counter + 1 WHERE box_number = '11023'";
                $stmt = $conn->prepare($sql);
                $stmt->execute();
                $current_route = "SELECT todays_route FROM route_counter WHERE box_number = '11023'";
                $cur_route = $conn->query($current_route);
                $route_value = $cur_route->fetch(PDO::FETCH_ASSOC);
                $route_today = $route_value['todays_route'];
                if($route_today != ""){
                    //if route is determined in database, even if street overlaps with another route it assigns passenger to the correct route
                    $sql = "UPDATE ndot_data SET stop_1 = stop_1 + 1 WHERE route_num = $route_today";
                    $stmt = $conn->prepare($sql);
                    $stmt->execute();
                    exit;
                }
                if(in_array($street, $route_11)) {
                    //first route exclusive street posts to server and updates counter with: todays route and takes all previous taps on said box and moves them to actual tracker table 
                    $update = "SELECT ridership_counter FROM route_counter WHERE box_number = '11023'";                
                    $today_route = "UPDATE route_counter SET todays_route = '42' WHERE box_number = '11023'";
                    $result = $conn->query($update);
                    $stmt = $conn->query($today_route);
                    $update_result = $result->fetch(PDO::FETCH_ASSOC);
                    $counter = $update_result['ridership_counter'];
                    if($counter != '0') {
                        $sql = "UPDATE ndot_data SET stop_1 = stop_1 + $counter WHERE route_num = '42'";
                        $stmt ->bindValue(':riders', $counter);
                        $stmt = $conn->prepare($sql);
                        $stmt->execute();
                        echo "Route exclusive street found.";
                        exit;
                    }
                }
                if(in_array($street, $route_12)) {
                    $update = "SELECT ridership_counter FROM route_counter WHERE box_number = '11023'";
                    $result = $conn->query($update);
                    $update_result = $result->fetch(PDO::FETCH_ASSOC);
                    $counter = $update_result['ridership_counter'];
                    if($counter != '0') {
                        $sql = "UPDATE ndot_data SET stop_1 = stop_1 + $counter WHERE route_num = '44'";
                        $stmt ->bindValue(':riders', $counter);
                        $stmt = $conn->prepare($sql);
                        $stmt->execute();
                        echo "Route exclusive street found.";
                        exit;
                    }
                } else {
                    echo "No route assigned";
                }
            }
            if($boxnumber == "11024") {
                $sql = "UPDATE route_counter SET ridership_counter = ridership_counter + 1 WHERE box_number = '11024'";
                $stmt = $conn->prepare($sql);
                $stmt->execute();
                if(in_array($street, $route_11)) {
                    echo $route_counter_1;
                }
                if(in_array($street, $route_12)) {
                    echo "Array two tested";
                } else {
                    
                }
            }
        }
    } elseif($location == "Atlanta") {
        $boxnumber = $_POST['boxnumber'] ? trim($_POST['boxnumber']): null;
        if($boxnumber == "110231") {
            echo("Second Number Check");
        } else {
            echo("Second Condition");
        }
    } else {
        echo("Failed both condtions");
    }
} catch(PDOException $e) {
    echo "Connection failed: " . $e->getMessage();
    }
?>