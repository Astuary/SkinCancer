function subtype1(filepath)

if contains(filepath, 'Benign')
   result = 'Benign' ;
elseif contains(filepath, 'Basal')
   result = 'Basal Cell Carcinoma' ;
elseif contains(filepath, 'Squamous')
   result = 'Squamous Cell Carcinoma' ;
else 
    result = 'Malignant Melanoma';
end

result

end