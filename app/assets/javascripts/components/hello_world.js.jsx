function HelloWorld(props) {
  return <React.Fragment>Greeting: {props.greeting}</React.Fragment>;
}

export default function MovieCard() {}

HelloWorld.propTypes = {
  greeting: PropTypes.string,
};
