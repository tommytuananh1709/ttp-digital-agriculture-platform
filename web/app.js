const form = document.getElementById('analyzeForm');
const spinner = document.getElementById('spinner');
const resultEl = document.getElementById('result');
const card = document.getElementById('card');
const raw = document.getElementById('raw');
const fillDemo = document.getElementById('fillDemo');

const API_BASE = '';

fillDemo.addEventListener('click', () => {
  document.getElementById('farmer_id').value = '22222222-2222-2222-2222-222222222222';
  document.getElementById('field_id').value = '33333333-3333-3333-3333-333333333333';
  document.getElementById('season_id').value = '44444444-4444-4444-4444-444444444444';
  document.getElementById('crop').value = 'sầu riêng';
  document.getElementById('user_note').value = 'Lá vàng nhiều, chậm lớn';
  document.getElementById('image_url').value = 'https://raw.githubusercontent.com/tommytuananh1709/ttp-digital-agriculture-platform/main/test_images/leaf-001.jpg';
});

async function fileToDataUrl(file){
  return new Promise((res, rej) => {
    const reader = new FileReader();
    reader.onload = () => res(reader.result);
    reader.onerror = rej;
    reader.readAsDataURL(file);
  });
}

form.addEventListener('submit', async (e) => {
  e.preventDefault();
  spinner.classList.remove('hidden');
  resultEl.classList.add('hidden');
  card.innerHTML = '';
  raw.textContent = '';

  const farmer_id = document.getElementById('farmer_id').value;
  const field_id = document.getElementById('field_id').value;
  const season_id = document.getElementById('season_id').value;
  const crop = document.getElementById('crop').value;
  const user_note = document.getElementById('user_note').value;
  let image_url = document.getElementById('image_url').value.trim();
  const image_file = document.getElementById('image_file').files[0];

  if(!image_url && image_file){
    try{
      image_url = await fileToDataUrl(image_file);
    }catch(err){
      alert('Không thể đọc file ảnh');
      spinner.classList.add('hidden');
      return;
    }
  }

  const payload = {
    farmer_id, field_id, season_id, crop, image_url, user_note
  };

  try{
    const res = await fetch(`${API_BASE}/api/v1/crop-analysis/analyze`, {
      method: 'POST',
      headers: {'Content-Type':'application/json'},
      body: JSON.stringify(payload)
    });

    if(!res.ok){
      const txt = await res.text();
      throw new Error(`API error ${res.status}: ${txt}`);
    }

    const data = await res.json();
    showResult(data, image_url);
  }catch(err){
    alert('Lỗi: ' + err.message);
  }finally{
    spinner.classList.add('hidden');
  }
});

function showResult(data, image_url){
  resultEl.classList.remove('hidden');
  const analysis = data.analysis || {};

  const title = document.createElement('h3');
  title.textContent = analysis.diagnosis || 'Không có chẩn đoán';

  const conf = document.createElement('p');
  conf.innerHTML = `<strong>Độ tin cậy:</strong> ${Math.round((analysis.confidence||0)*100)}%`;

  const severity = document.createElement('p');
  severity.innerHTML = `<strong>Độ nghiêm trọng:</strong> ${analysis.severity}`;

  const symptoms = document.createElement('p');
  symptoms.innerHTML = `<strong>Triệu chứng:</strong> ${(analysis.symptoms_detected||[]).join(', ')}`;

  const steps = document.createElement('div');
  steps.innerHTML = '<strong>Hành động gợi ý:</strong>';
  const ol = document.createElement('ol');
  (analysis.recommended_actions||[]).forEach(s => {
    const li = document.createElement('li'); li.textContent = s; ol.appendChild(li);
  });
  steps.appendChild(ol);

  card.appendChild(title);
  card.appendChild(conf);
  card.appendChild(severity);
  card.appendChild(symptoms);
  card.appendChild(steps);

  if(image_url){
    const img = document.createElement('img');
    img.src = image_url;
    img.className = 'preview';
    card.appendChild(img);
  }

  raw.textContent = JSON.stringify(data, null, 2);
}
