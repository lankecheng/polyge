<?php 
echo "{\"countries\":[";
$i=0;
foreach($locations as $key=>$value) {
    echo "{\"id\":".$key.",\"country\":\"".$value['country']."\"";
    if (array_key_exists('provinces', $value)) {
        echo ",\"provinces\":[";
        $j=0;
        foreach($value['provinces'] as $pKey=>$pValue) {
            echo "{\"id\":".$pKey.",\"province\":\"".$pValue['province']."\"";
            if (array_key_exists('citys', $pValue)) {
                echo ",\"cities\":[";
                $k=0;
                foreach($pValue['citys'] as $cKey=>$cValue) {
                    echo "{\"id\":".$cKey.",\"city\":\"".$cValue."\"}";
                    if ($k < count($pValue['citys']) - 1) {
                        echo ",";
                    }
                    $k++;
                }
                echo "]";
            }
            echo "}";
            if ($j < count($value['provinces']) - 1) {
                echo ",";
            }
            $j++;
        }
        echo "]";
    }
    echo "}";
    if ($i < count($locations) - 1) {
        echo ",";
    }
    $i++;
}
echo "]}"
?>