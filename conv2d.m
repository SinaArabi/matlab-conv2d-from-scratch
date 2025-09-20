clc ;
clear all ;
close all ;

%img = imread('./images/andrew.jpeg');
%img = imread('./images/bengio.jpeg');
%img = imread('./images/goodfellow.jpeg');
img = imread('./images/leskovec.jpeg');

horizontal_edge = [-1,-1,-1; 0,0,0 ;1,1,1] ;
               
vertical_edge = [-1,0,1;-1,0,1;-1,0,1] ;

sharpening = [0,-1,0;-1,5,-1;0,-1,0] ;

weighted_averaging_3x3 = (1/16).*[1, 2, 1; 2, 4, 2; 1, 2, 1] ; 

layer_one_filters = cat(3,horizontal_edge,vertical_edge,sharpening, weighted_averaging_3x3) ;

robert_x = [1, 0; 0, -1] ;    

robert_y = [0, +1;-1, 0] ;

averaging_2x2 = (1/4).*[1, 1; 1, 1] ;

layer_two_filters = cat(3, robert_x, robert_y, averaging_2x2) ;

layer_one_output = conv2D(img, layer_one_filters, 1, 'same');

figure, 
sgtitle('Layer one images'),

subplot(1,5,1),imshow(img), title('Main image');
subplot(1,5,2),imshow((layer_one_output(:, :,1))), title('horizontal edge') ;
subplot(1,5,3),imshow(layer_one_output(:, :,2)), title('vertical edge') ;
subplot(1,5,4),imshow(layer_one_output(:, :,3)), title('sharpening') ;
subplot(1,5,5),imshow(layer_one_output(:, :,4)), title('weighted averaging 3x3') ;



layer_two_output = conv2D(layer_one_output,layer_two_filters,2, 'valid');

figure,
sgtitle('Layer two images'),

subplot(1,3,1), imshow((layer_two_output(:, :,1))), title('robert x') ;
subplot(1,3,2), imshow(layer_two_output(:, :,2)), title('robert y') ;
subplot(1,3,3), imshow(layer_two_output(:, :,3)), title('averaging 2x2') ;



function output = pad(img,f)
    p = (f-1) /2 ;
    output = zeros(size(img,1) + 2 * p, size(img,2) + 2 * p);
    output(p+1: size(img,1) + p , p+1 : size(img,2) + p) = img ;

end




function output = conv2D(img, filters, stride, padding)
    f = size(filters,1) ;
    p = 0 ;

    if (strcmp(padding,"same"))  
        p = (f -1) / 2 ;
        paded_img = zeros(size(img,1) + 2 * p, size(img,2) + 2 * p,size(img,3)); 
        for k=1 : size(img,3)
            paded_img(:,:,k) = pad(img(:,:,k),f) ;
        end  
        img = paded_img ;
    end

    m=size(img,1) ;
    n=size(img,2) ;
    
    output_m = ((m + 2*p - f)/stride) +1 ;
    output_n = ((n + 2*p - f)/stride) +1 ;

    output = zeros(ceil(output_m), ceil(output_n),size(filters,3));

    for i=1 : size(filters,3)
        for j=1 : size(img,3)
            output_row_index = 1;
            for row = 1:stride:size(img,1)-(f-1) 
                output_col_index = 1;
                for col=1:stride:size(img,2)-(f-1)
                    local = img(row:row +f-1, col:col+f-1,j);
                    kernel_dim = size(filters,1);
                    conv = double(local) .* filters(1:kernel_dim,1:kernel_dim,i) ;
                    output(output_row_index,output_col_index,i) =  output(output_row_index,output_col_index,i) + sum(conv,"all");
                    output_col_index = output_col_index +1;
                end      

                output_row_index = output_row_index +1 ;
            end
            %output(1:out,1:col,i) = uint8(output(1:row,1:col,i));
        end
    end        
    
end




