import Response from 'ember-cli-mirage/response';

export default function() {

  this.namespace = 'api';

  this.get('/students');
  this.get('/students/:id');
  this.patch('/students/2', () => new Response(500, { 'Content-Type': 'text/plain' }, 'Student id 2 geht nich!!!'));
  this.patch('/students/:id');
  this.post('/students', ({ students }, { requestBody }) => {
    const { data: { attributes } } = JSON.parse(requestBody);

    const errors = Object.keys(attributes)
      .filter(attr => attributes[attr] === "error")
      .map(attr => ({
        source: { pointer: `/data/attributes/${attr}` },
        status: "422",
        title: `${attr} ausfüllen!`
      })
    );

    if (errors.length) {
      return new Response(
        422,
        {},
        { errors }
      );
    }

    const student = students.create(attributes);

    return student;
  });

  this.post('/token', (schema, { requestBody }) => {
    let params = new URLSearchParams(requestBody);
    let username = params.get('username');
    let password = params.get('password');

    if (username !== 'Hans' || password !== 'Admin') {
      return new Response(
        401,
        { 'Content-Type': 'application/json' },
        { error: 'Login nicht möglich. Bitte kontrolliere deine Login-Daten' }
      );
    }

    return {
      access_token: 'abcdefghijklmnopqrstuvwxyz',
      token_type: 'bearer'
    };
  });

  this.get('/trips');
}
