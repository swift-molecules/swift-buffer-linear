import Ordinal
import Affine_Standard_Library_Integration
public import Buffer
public import Memory_Allocator
public import Memory
public import Memory_Small
import Ordinal_Standard_Library_Integration
public import Storage_Memory
import Storage

extension Buffer.Linear where S: ~Copyable {

    @resultBuilder
    public enum Builder {

        @inlinable
        public static func buildExpression<E: ~Copyable>(
            _ expression: consuming E
        ) -> Buffer<Storage<Memory.Allocator<Memory.Small<0>>>.Contiguous<E>>.Linear
        where S == Storage<Memory.Allocator<Memory.Small<0>>>.Contiguous<E> {
            var result = Buffer<Storage<Memory.Allocator<Memory.Small<0>>>.Contiguous<E>>.Linear(
                minimumCapacity: .one
            )
            result.append(consume expression)
            return result
        }

        @inlinable
        public static func buildExpression<E: ~Copyable>(
            _ expression:
                consuming Buffer<Storage<Memory.Allocator<Memory.Small<0>>>.Contiguous<E>>.Linear
        ) -> Buffer<Storage<Memory.Allocator<Memory.Small<0>>>.Contiguous<E>>.Linear
        where S == Storage<Memory.Allocator<Memory.Small<0>>>.Contiguous<E> {
            consume expression
        }

        @inlinable
        public static func buildExpression<E: ~Copyable>(
            _ expression: consuming E?
        ) -> Buffer<Storage<Memory.Allocator<Memory.Small<0>>>.Contiguous<E>>.Linear
        where S == Storage<Memory.Allocator<Memory.Small<0>>>.Contiguous<E> {
            var result = Buffer<Storage<Memory.Allocator<Memory.Small<0>>>.Contiguous<E>>.Linear(
                minimumCapacity: .zero
            )
            if let value = consume expression {
                result.append(consume value)
            }
            return result
        }

        @inlinable
        public static func buildPartialBlock<E: ~Copyable>(
            first: consuming Buffer<Storage<Memory.Allocator<Memory.Small<0>>>.Contiguous<E>>.Linear
        ) -> Buffer<Storage<Memory.Allocator<Memory.Small<0>>>.Contiguous<E>>.Linear
        where S == Storage<Memory.Allocator<Memory.Small<0>>>.Contiguous<E> {
            consume first
        }

        @inlinable
        public static func buildPartialBlock<E: ~Copyable>(
            first: Void
        ) -> Buffer<Storage<Memory.Allocator<Memory.Small<0>>>.Contiguous<E>>.Linear
        where S == Storage<Memory.Allocator<Memory.Small<0>>>.Contiguous<E> {
            Buffer<Storage<Memory.Allocator<Memory.Small<0>>>.Contiguous<E>>.Linear(
                minimumCapacity: .zero
            )
        }

        @inlinable
        public static func buildPartialBlock<E: ~Copyable>(
            first: Never
        ) -> Buffer<Storage<Memory.Allocator<Memory.Small<0>>>.Contiguous<E>>.Linear
        where S == Storage<Memory.Allocator<Memory.Small<0>>>.Contiguous<E> {}

        @inlinable
        public static func buildPartialBlock<E: ~Copyable>(
            accumulated:
                consuming Buffer<Storage<Memory.Allocator<Memory.Small<0>>>.Contiguous<E>>.Linear,
            next: consuming Buffer<Storage<Memory.Allocator<Memory.Small<0>>>.Contiguous<E>>.Linear
        ) -> Buffer<Storage<Memory.Allocator<Memory.Small<0>>>.Contiguous<E>>.Linear
        where S == Storage<Memory.Allocator<Memory.Small<0>>>.Contiguous<E> {
            var result = consume accumulated
            var rest = consume next
            while !rest.isEmpty {
                result.append(rest.remove.first())
            }
            return result
        }

        @inlinable
        public static func buildBlock<E: ~Copyable>()
            -> Buffer<Storage<Memory.Allocator<Memory.Small<0>>>.Contiguous<E>>.Linear
        where S == Storage<Memory.Allocator<Memory.Small<0>>>.Contiguous<E> {
            Buffer<Storage<Memory.Allocator<Memory.Small<0>>>.Contiguous<E>>.Linear(
                minimumCapacity: .zero
            )
        }

        @inlinable
        public static func buildOptional<E: ~Copyable>(
            _ component:
                consuming Buffer<Storage<Memory.Allocator<Memory.Small<0>>>.Contiguous<E>>.Linear?
        ) -> Buffer<Storage<Memory.Allocator<Memory.Small<0>>>.Contiguous<E>>.Linear
        where S == Storage<Memory.Allocator<Memory.Small<0>>>.Contiguous<E> {
            if let result = consume component {
                return consume result
            }
            return Buffer<Storage<Memory.Allocator<Memory.Small<0>>>.Contiguous<E>>.Linear(
                minimumCapacity: .zero
            )
        }

        @inlinable
        public static func buildEither<E: ~Copyable>(
            first: consuming Buffer<Storage<Memory.Allocator<Memory.Small<0>>>.Contiguous<E>>.Linear
        ) -> Buffer<Storage<Memory.Allocator<Memory.Small<0>>>.Contiguous<E>>.Linear
        where S == Storage<Memory.Allocator<Memory.Small<0>>>.Contiguous<E> {
            consume first
        }

        @inlinable
        public static func buildEither<E: ~Copyable>(
            second: consuming Buffer<Storage<Memory.Allocator<Memory.Small<0>>>.Contiguous<E>>.Linear
        ) -> Buffer<Storage<Memory.Allocator<Memory.Small<0>>>.Contiguous<E>>.Linear
        where S == Storage<Memory.Allocator<Memory.Small<0>>>.Contiguous<E> {
            consume second
        }

        @inlinable
        public static func buildLimitedAvailability<E: ~Copyable>(
            _ component:
                consuming Buffer<Storage<Memory.Allocator<Memory.Small<0>>>.Contiguous<E>>.Linear
        ) -> Buffer<Storage<Memory.Allocator<Memory.Small<0>>>.Contiguous<E>>.Linear
        where S == Storage<Memory.Allocator<Memory.Small<0>>>.Contiguous<E> {
            consume component
        }
    }
}

extension Buffer.Linear where S: ~Copyable {

    @inlinable
    public init<E: ~Copyable>(@Buffer.Linear.Builder _ builder: () -> Self)
    where S == Storage<Memory.Allocator<Memory.Small<0>>>.Contiguous<E> {
        self = builder()
    }
}

extension Buffer.Linear.Builder where S: ~Copyable {

    @inlinable
    public static func buildExpression<E, Seq: Swift.Sequence>(
        _ expression: Seq
    ) -> Buffer<Storage<Memory.Allocator<Memory.Small<0>>>.Contiguous<E>>.Linear
    where S == Storage<Memory.Allocator<Memory.Small<0>>>.Contiguous<E>, E: Copyable, Seq.Element == E {
        var result = Buffer<Storage<Memory.Allocator<Memory.Small<0>>>.Contiguous<E>>.Linear(
            minimumCapacity: .zero
        )
        for value in expression {
            result.append(value)
        }
        return result
    }
}
