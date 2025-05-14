# to increase the load in the LB, to check HPA
for j in {1..10}; do  
    for i in {1..1000}; do  
        curl -s -o /dev/null -w "%{http_code}\n" http://a580e03ecd1474172a24f612a7f290cc-2047117297.ap-south-1.elb.amazonaws.com/ &  
    done  
    wait  # Wait for all background curl processes to finish before next iteration
done