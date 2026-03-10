const fs = require('fs');
const newFooter = fs.readFileSync('new_footer.html', 'utf8');

const files = [
    'src/main/webapp/WEB-INF/views/home.jsp',
    'src/main/webapp/WEB-INF/views/dashboard.jsp'
];

files.forEach(file => {
    try {
        let content = fs.readFileSync(file, 'utf8');
        content = content.replace(/<!-- ========== FOOTER ========== -->[\s\S]*?<\/footer>/g, newFooter);
        fs.writeFileSync(file, content, 'utf8');
        console.log(`Replaced footer in ${file}`);
    } catch (e) {
        console.error(`Error in ${file}:`, e);
    }
});
